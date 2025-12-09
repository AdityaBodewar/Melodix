import React from 'react'
import GetAllMusic from '../Components/GetAllMusic'
import NavBar from '../Components/NavBar'

const HomePage = () => {
  return (
    <>
    
    <div className="nav">
      <NavBar/>
    </div>
    <div className="container flex ">

       <div className="head h-150 w-30 border-2 border-blue-100 bg-amber-600 rounded-2xl">
        <div className='overflow-y-auto h-full'>
          <GetAllMusic/>
        </div>



    </div>
    <div className="ml-5 w-300 h-150 border-black border-2 rounded-2xl ">
      <div className="overflow-x-auto w-full "  >
      <GetAllMusic/>
      </div>
    </div>



    <div className="footer"></div> 
    </div>
      
    
    
    </>
  )
}

export default HomePage