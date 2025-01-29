// Next.js Custom Route Handler: https://nextjs.org/docs/app/building-your-application/routing/router-handlers
import prisma from "@/lib/prisma";
import { PrismaClient } from "@prisma/client/extension";
import { createSchema, createYoga, YogaInitialContext } from "graphql-yoga";
import { validateJwtAccessToken } from "oauth4webapi";

interface NextContext {
  params: Promise<Record<string, string>>;
  prisma: PrismaClient;
  user: User | null;
}

type User = {
  id: string;
  canWrite: boolean;
};

const as = {
  issuer: "https://accounts.hatena.ne.jp",
  authorization_endpoint: "https://accounts.hatena.ne.jp/oauth2/authorize",
  token_endpoint: "https://accounts.hatena.ne.jp/oauth2/token",
  jwks_uri: "https://accounts.hatena.ne.jp/oauth2/jwks",
  response_types_supported: ["code"],
  grant_types_supported: ["authorization_code", "refresh_token"],
  token_endpoint_auth_methods_supported: [
    "client_secret_basic",
    "client_secret_post",
  ],
  revocation_endpoint: "https://accounts.hatena.ne.jp/oauth2/revoke",
  revocation_endpoint_auth_methods_supported: [
    "client_secret_basic",
    "client_secret_post",
  ],
  introspection_endpoint: "https://accounts.hatena.ne.jp/oauth2/introspect",
  introspection_endpoint_auth_methods_supported: [
    "client_secret_basic",
    "client_secret_post",
  ],
  code_challenge_methods_supported: ["plain", "S256"],
};

async function createContext({ params, request }: YogaInitialContext) {
  let user: User | null = null;

  if (request.headers.get("Authorization")) {
    const claim = await validateJwtAccessToken(
      as,
      request,
      "https://hatenaid-demo.hatelabo.jp/"
    );
    const account = await prisma.account.findUnique({
      where: {
        provider_providerAccountId: {
          provider: "hatena",
          providerAccountId: claim.sub,
        },
      },
      include: {
        user: true,
      },
    });

    if (account) {
      user = {
        id: account.user.id,
        canWrite:
          claim.scope?.includes(
            "hatenaid-demo.hatelabo.jp/hatenaid-demo:write"
          ) ?? false,
      };
    } else {
      // TODO: アカウントがなかった時の処理を考える
    }
  }

  return {
    params,
    prisma,
    user,
  };
}

const { handleRequest } = createYoga<NextContext>({
  schema: createSchema({
    typeDefs: /* GraphQL */ `
      type Query {
        greetings: String
        questions: [Question!]!
        question(id: ID!): Question
      }

      type Question {
        id: ID!
        body: String!
        answers: [Answer!]!
      }

      type Answer {
        id: ID!
        body: String!
      }

      type Mutation {
        addQuestion(body: String!): Question!
        addAnswer(body: String!, questionId: ID!): Answer!
      }
    `,
    resolvers: {
      Query: {
        greetings: () => "挨拶です！",
        questions: async (_parent, _args, { prisma }) => {
          return prisma.question.findMany({
            orderBy: {
              id: "desc",
            },
          });
        },
        question: async (_parent, { id }, { prisma }) => {
          return prisma.question.findUnique({
            where: {
              id,
            },
            include: {
              answers: {
                orderBy: {
                  id: "desc",
                },
              },
            },
          });
        },
      },
      Mutation: {
        addQuestion: async (_parent, { body }, { prisma }) => {
          return prisma.question.create({
            data: {
              body,
            },
          });
        },
        addAnswer: async (_parent, { body, questionId }, { prisma, user }) => {
          if (!user?.canWrite) {
            throw new Error("権限がありません");
          }
          return prisma.answer.create({
            data: {
              body,
              questionId: questionId,
              userId: user.id,
            },
          });
        },
      },
    },
  }),

  // While using Next.js file convention for routing, we need to configure Yoga to use the correct endpoint
  graphqlEndpoint: "/api/graphql",

  // Yoga needs to know how to create a valid Next response
  fetchAPI: { Response },

  context: createContext,
});

export {
  handleRequest as GET,
  handleRequest as POST,
  handleRequest as OPTIONS,
};
