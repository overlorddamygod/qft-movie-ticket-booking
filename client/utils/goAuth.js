import auth from "go-auth-client"

const client = auth.createClient( process.env.NEXT_PUBLIC_GO_AUTH_SERVER_URL )

export default client;