"use client"

import Head from "next/head";
import {useRouter} from "next/navigation";

export default function Home() {

  const { push } = useRouter();

  function btnLoginClick(){
    push("/bet");
  }

  return (
    <>
      <Head>
        <title>BetCandidate | Login</title>
        <meta charSet="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
      </Head>
      <div className="container px-4 py-5">
        <div className="row flex-lg-row-reverse align-items-cneter g-5 py-5">
          <div className="col-10">
            <h1 className="display-5 fw-bold text-body-emphasis lh-1 mb-3">BetCandidate</h1>
            <p className="lead">Regras:</p>
            <p className="lead"> -Só é permitido a escolha de um cadidato.</p>
            <p className="lead"> -A data limite da escolha é 04/11/2024.</p>
            <p className="lead"> -O resgate ficará disponível até 7 dias depois do resultado da votação.</p>
            <p className="lead"> -O valor do prémio será divido para todos os acrtadores do lado vencedor.</p>
            <p className="message"></p>
          </div>
        </div>
        <footer className="d-flex flex-wrap justify-content-between align-items-center py-3 my-4 border-top">
          <p className="col-4 mb-0 text-body-secondary">
            &copy;2024 BetCandidate, Inc
          </p>
          <ul className="nav col-4 justify-content-end">
            <li className="nav-item"><a href="/" className="nav-link px-2 text-body-secondary">Home</a></li>
            <li className="nav-item"><a href="/about" className="nav-link px-2 text-body-secondary">About</a></li>
          </ul>
        </footer>
      </div>
    </>
  );
}
