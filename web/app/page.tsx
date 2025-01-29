import prisma from "@/lib/prisma";
import { revalidatePath } from "next/cache";

export default async function Home() {
  async function addQuestion(form: FormData) {
    "use server";
    await prisma.question.create({
      data: {
        body: form.get("body") as string,
      },
    });
    revalidatePath("/");
  }

  const questions = await prisma.question.findMany({
    orderBy: {
      id: "desc",
    },
  });

  return (
    <main className="max-w-xl mx-auto flex flex-col items-center justify-center">
      <section className="w-full">
        <form action={addQuestion} className="flex flex-col gap-4">
          <h2 className="flex justify-between items-center">
            <p>匿名で質問を投稿しよう！</p>
            <button className="btn btn-primary">質問する</button>
          </h2>
          <textarea
            name="body"
            placeholder="質問する"
            className="textarea textarea-bordered textarea-lg w-full"
          ></textarea>
        </form>
      </section>
      <section className="w-full">
        <h2>質問一覧</h2>
        <div className="flex flex-col gap-4">
          {questions.map((question) => (
            <div
              key={question.id}
              className="card bg-base-100 w-full shadow-xl"
            >
              <div className="card-body">
                <h2 className="card-title">{question.body}</h2>
                <div className="card-actions justify-end">
                  <button className="btn btn-primary">詳細を見る</button>
                </div>
              </div>
            </div>
          ))}
        </div>
      </section>
    </main>
  );
}
