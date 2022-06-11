// Next.js API route support: https://nextjs.org/docs/api-routes/introduction

export default function handler(req, res) {
  if (req.method === "POST") {
    // set auth token from header to cookie
    res.setHeader(
      "Set-Cookie",
      `authToken=${req.headers.authorization}; path=/; httponly;`
    );
    res.status(200).json({ error: false });
  }
  res.status(404);
}
