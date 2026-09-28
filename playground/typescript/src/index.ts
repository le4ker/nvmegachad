import {greet} from "./greeter"
const names:string[]=["Ada","Linus","Grace"]
for(const name of names){console.log(greet(name))}
const n:number = "oops" // tsserver: type error
