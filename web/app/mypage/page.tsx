import { auth } from "@/auth";
import { redirect } from "next/navigation";

export default async function Mypage() {
  const session = await auth();
  if (!session) {
    redirect("/api/auth/signin");
  }

  return (
    <main className="max-w-xl mx-auto flex flex-col items-center justify-center">
      <section className="w-full">
        <h2>マイページ</h2>
        <p>ようこそ、{session?.user?.name}さん</p>
      </section>
    </main>
  );
}
