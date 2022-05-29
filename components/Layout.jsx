import Link from "next/link";

export default function Layout({ auto=true, children }) {
  return (
    <div className={`${auto ? "max-w-5xl mx-auto" : ""}`}>
      <header className={`${!auto ? "max-w-5xl mx-auto" : ""}`}>
        <Link href="/">
          <h1 className="text-5xl py-2 cursor-pointer">QFT</h1>
        </Link>
      </header>
      {children}
    </div>
  );
}
