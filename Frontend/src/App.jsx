import HomePage from './Pages/HomePage'
import { BrowserRouter as Router , Routes,Route } from 'react-router-dom'
import PlayerPage from './Pages/PlayerPage'

const App = () => {
  return (
   
<Router>


<Routes>

  <Route path='/' element={<HomePage/>}/>
   <Route path='/player' element={<PlayerPage/>}/>

</Routes>

</Router>
    
  )
}

export default App