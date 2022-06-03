import Link from "next/link";

export default function Layout({ auto=true, children }) {
  return (
    <div className={`${auto ? "max-w-xl mx-auto md:max-w-5xl px-5 md:px-0" : ""}`}>
      <header className={`${!auto ? "max-w-xl mx-auto md:max-w-5xl px-5 md:px-0" : ""}`}>
        <Link href="/">
          <h1 className="text-5xl py-2 cursor-pointer">QFT</h1>
        </Link>
      </header>
      {children}
    </div>
  );
}
