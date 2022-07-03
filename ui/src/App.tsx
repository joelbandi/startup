import axios from "axios"
import { useEffect, useState } from "react"

export const App = () => {
  const [text, setText] = useState('loading...')
  useEffect(() => {
    setTimeout(() => axios.get('api/').then((response) => setText(response.data.text)), 2000)
  })

  return (
    <div className="App">
      Text from backend: {text}
    </div>
  )
}
