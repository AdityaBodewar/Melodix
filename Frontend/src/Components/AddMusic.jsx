import axios from 'axios';
import React from 'react'
import { useState } from 'react';

const AddMusic = () => {

    const [data,setData]=useState({"title":"","singer":"","type":"","language":""});
    const [image,setImage]=useState(null);
    const [audio,setAudio]=useState(null);

const handleChange=(e)=>{

  const {name,value,files}=e.target;

  if(files)
  {
    if(name=="image")
    {
        setImage(files[0]);
    }
    if(name=="audio")
    {
        setAudio(files[0])
    }  
}
else{
setData({...data,[name]:value});
}   
}
const handleSubmit=async()=>{

    try{
   
        if(!data.title || !data.singer || !data.language || !data.type || !image || !audio)
        {
            alert("all fields are required");
            return ; 
        }
    
    const formdata=new FormData();

    formdata.append("title",data.title);
    formdata.append("singer",data.singer);
    formdata.append("type",data.type);
    formdata.append("language",data.language);
    formdata.append("image",image);
    formdata.append("audio",audio);


  const res=await axios.post("http://localhost:5000/addmusic",formdata,{headers:{"Content-Type":"multipart/form-data",},});
alert(res.data.message);   
}
    catch(e)
    {
        alert("song uploading failed");
        console.log(e);
    }
}
  return (
   <>

   <div className=' flex w-full h-170 justify-center items-center'>
   <fieldset className="fieldset bg-base-200 border-green-700 border-2 rounded-box w-xs  p-10">
  <legend className="fieldset-legend">Add Song</legend>

  <label className="label">Title</label>
  <input type="text" className="input" placeholder="Title" name='title' value={data.title} onChange={handleChange} required />

  <label className="label">Singer</label>
  <input type="text" className="input" placeholder="Singer" name='singer' value={data.singer} onChange={handleChange} />

    <label className="label">Type</label>
  <input type="text" className="input" placeholder="Type" name='type' value={data.type} onChange={handleChange} />

      <label className="label">Language</label>
  <input type="text" className="input" placeholder="Language" name='language' value={data.language} onChange={handleChange} />

        <label className="label">Cover Image</label>
  <input type="file" className='border-black' accept='image/*' name='image'  onChange={handleChange} />

  <label className="label">Song</label>
  <input type="file" className='border-black' accept='Audio/*'  name='audio'  onChange={handleChange}/>

  <button className="btn btn-success mt-4 " onClick={handleSubmit}>Add Songs</button>
</fieldset>
   </div>
   </>
  )
}

export default AddMusic