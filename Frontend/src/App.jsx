import HomePage from './Pages/HomePage'
import { BrowserRouter as Router , Routes,Route } from 'react-router-dom'
import PlayerPage from './Pages/PlayerPage'
import LoginPage from './Pages/LoginPage'
import RegisterPage from './Pages/RegisterPage'


const App = () => {
  return (
    
<Router>


<Routes>

  <Route path='/' element={<HomePage/>}/>
   <Route path='/player' element={<PlayerPage/>}/>
   <Route path='/login' element={<LoginPage/>}/>
   <Route path='/register' element={<RegisterPage/>}/>

</Routes>

</Router>
    
  )
}

export default App