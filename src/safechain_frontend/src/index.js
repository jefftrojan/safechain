import {
  createActor,
  safechain_backend,
} from "../../declarations/safechain_backend";
import { AuthClient } from "@dfinity/auth-client";
import { HttpAgent } from "@dfinity/agent";

let actor = safechain_backend;
console.log(process.env.CANISTER_ID_INTERNET_IDENTITY);

const whoAmIButton = document.getElementById("whoAmI");
whoAmIButton.onclick = async (e) => {
  e.preventDefault();
  whoAmIButton.setAttribute("disabled", true);
  const principal = await actor.whoami();
  whoAmIButton.removeAttribute("disabled");
  document.getElementById("principal").innerText = principal.toString();
  return false;
};

const loginButton = document.getElementById("login");
loginButton.onclick = async (e) => {
  e.preventDefault();
  let authClient = await AuthClient.create();
  // start the login process and wait for it to finish
  await new Promise((resolve) => {
    authClient.login({
      identityProvider: "https://identity.ic0.app",
      onSuccess: resolve,
    });
  });
  const identity = authClient.getIdentity();
  const agent = new HttpAgent({ identity });
  actor = createActor(process.env.CANISTER_ID_safechain_BACKEND, {
    agent,
  });

  // Redirect to a new route (replace 'new-route' with your desired route)
  window.location.href = '?canisterId=be2us-64aaa-aaaaa-qaabq-cai&id=bkyz2-fmaaa-aaaaa-qaaaq-cai';

  return false;
};
