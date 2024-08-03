import { Elm } from './src/Main.elm'

const apiUrl = process.env.API_URL
const apiKey = process.env.API_KEY

Elm.Main.init({
  node: document.getElementById('app'),
  flags: {
    apiUrl,
    apiKey
  }
})

