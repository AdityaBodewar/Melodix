import axios from 'axios';
import { useEffect } from 'react';
import { useState } from 'react';
import Player from './Player';



const GetAllMusic = () => {

const [song,setSong]=useState([]);
const [music,setMusic]=useState(null);

useEffect(()=>{

        axios.get("http://localhost:5000/getallmusic")
    .then((res)=>{ setSong(res.data.data)})
    .catch((error)=>{console.log(error.data.message)});

},[])



  return (
    <>
<div className='flex flex-wrap justify-around align-super w-fit'>
    {song.map((item)=>{
        return(
            
 <div className="card bg-base-100 w-fir h-fit  shadow-sm  border-green-300  mt-5 p-5 hover:bg-gray-600 group" key={item._id}>
  <figure>
     <div className="relative w-full h-44 overflow-hidden rounded-xl">
    <img
      src={item.Image}
      className='w-40 h-50 rounded-2xl' />
       <button
  onClick={()=>{setMusic(item.Song)}}
  className="absolute bottom-2 right-2 bg-green-700 text-white  w-12 h-12 py-1 rounded-full
         rounded opacity-0 group-hover:opacity-100 transition duration-300">
 play
</button>
<Player songurl={music}/>
</div>
  </figure>
  
    <h2 className="card-title text-3xl p-0 mt-5 w-40">
      {item.Title}
    </h2>
     <h3  className='text-gray-400 mt-3'>{item.Singer}</h3>
    {/*+
    <p className='text-gray-400 mt-0'>{item.Type}</p>
    <p  className='text-gray-400 mt-0'>{item.Language}</p> */}
    
 
  
  
</div>


    )})}
    </div>
    </>
  )
}

export default GetAllMusic