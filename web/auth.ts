import { PrismaAdapter } from "@auth/prisma-adapter";
import NextAuth from "next-auth";
import { Provider } from "next-auth/providers";
import prisma from "./lib/prisma";

const hatenaidOAuthProvider: Provider = {
  id: "hatena",
  name: "Hatena",
  type: "oidc",
  issuer: "https://accounts.hatena.ne.jp",
  authorization: { params: { scope: "openid profile" } },
  idToken: true,
  checks: ["state"],
  profile(profile) {
    return {
      id: profile.sub,
      name: profile.preferred_username,
      image: profile.picture,
    };
  },
  clientId: process.env.HATENA_CLIENT_ID,
  clientSecret: process.env.HATENA_CLIENT_SECRET,
};

export const { handlers, signIn, signOut, auth } = NextAuth({
  adapter: PrismaAdapter(prisma),
  providers: [hatenaidOAuthProvider],
});
