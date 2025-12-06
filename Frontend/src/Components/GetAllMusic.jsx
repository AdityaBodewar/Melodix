import axios from 'axios';
import React from 'react'
import { useEffect } from 'react';
import { useState } from 'react'

const GetAllMusic = () => {

const [song,setSong]=useState([]);

useEffect(()=>{

        axios.get("http://localhost:5000/getallmusic")
    .then((res)=>{ setSong(res.data.data)})
    .catch((error)=>{console.log(error.data.message)});

},[])

  return (
    <>
<div className='flex flex-wrap justify-around align-super'>
    {song.map((item)=>{
        return(
            
 <div className="card bg-base-100 w-fit  shadow-sm border-green-300 border-1 mt-5" key={item._id}>
  <figure>
    <img
      src={item.Image}
      className='w-70 h-70' />
  </figure>
  <div className="card-body">
    <h2 className="card-title">
      {item.Title}
    </h2>
    <h3  className='text-gray-400 mt-0'>{item.Singer}</h3>
    <p className='text-gray-400 mt-0'>{item.Type}</p>
    <p  className='text-gray-400 mt-0'>{item.Language}</p>
    <div className="card-actions justify-end">
      <div className="badge badge-outline">Play</div>
    </div>
  </div>
</div>


    )})}
    </div>
    </>
  )
}

export default GetAllMusic