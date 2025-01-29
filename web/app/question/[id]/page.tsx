import { auth } from "@/auth";
import prisma from "@/lib/prisma";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";

export default async function Question({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const question = await prisma.question.findUnique({
    where: {
      id: id,
    },
    include: {
      answers: {
        orderBy: {
          id: "desc",
        },
      },
    },
  });

  if (!question) {
    return <div>質問が見つかりませんでした</div>;
  }

  async function addAnswer(form: FormData) {
    "use server";
    const session = await auth();
    const userId = session?.user?.id;
    if (!userId) {
      redirect("/api/auth/signin");
    }

    await prisma.answer.create({
      data: {
        body: form.get("body") as string,
        questionId: id,
        userId: userId,
      },
    });
    revalidatePath(`/question/${id}`);
  }

  return (
    <main className="max-w-xl mx-auto flex flex-col items-center justify-center gap-5">
      <section className="w-full">
        <h2>質問詳細</h2>
        <div className="card bg-base-100 w-full shadow-xl">
          <div className="card-body">
            <h2 className="card-title">{question.body}</h2>
          </div>
        </div>
      </section>
      <section className="w-full">
        <h2>回答する</h2>
        <form action={addAnswer} className="flex flex-col gap-4">
          <textarea
            name="body"
            placeholder="回答する"
            className="textarea textarea-bordered textarea-lg w-full"
          ></textarea>
          <button className="btn btn-primary">回答する</button>
        </form>
      </section>
      <section className="w-full">
        <h2>回答一覧</h2>
        <div className="flex flex-col gap-4">
          {question.answers.map((answer) => (
            <div key={answer.id} className="card bg-base-100 w-full shadow-xl">
              <div className="card-body">
                <h2 className="card-title">{answer.body}</h2>
              </div>
            </div>
          ))}
        </div>
      </section>
    </main>
  );
}
