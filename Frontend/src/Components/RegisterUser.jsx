import axios from 'axios';
import React, { useState } from 'react'

const RegisterUser = () => {

const [user,setUser]=useState({"Fullname":"","Username":"","Email":"","Password":""});


const handleChange=(e)=>{

setUser({...user,[e.target.name]:e.target.value});

} 

const handleSubmit=()=>{
   
    axios.post("http://localhost:5000/registeruser",user)
    .then(res=>{alert(res.data.message);})
    .catch(error=>{alert(res.data.message);
        console.log(error.data.error);
    });
}
  return (
    <>

    <fieldset className="fieldset bg-base-200 border-base-300 rounded-box w-xs border p-4">
  <legend className="fieldset-legend">Register user</legend>

  <label className="label">Full Name</label>
  <input type="text" className="input" placeholder="Full Name" value={user.Fullname} name='Fullname' onChange={handleChange}/>

  <label className="label">Username</label>
  <input type="text" className="input" placeholder="Username" value={user.Username} name='Username' onChange={handleChange} />

  <label className="label">Email</label>
  <input type="email" className="input" placeholder="Email" value={user.Email} name='Email' onChange={handleChange} />

  <label className="label">Password</label>
  <input type="password" className="input" placeholder="Password"  value={user.Password} name='Password' onChange={handleChange}/>

  <button onClick={handleSubmit} className="btn btn-neutral mt-4">Register</button>
  <p className='text-[15px] p-5 '>already have an account ? <a className='text-blue-600 ' href="/login">Login </a></p>
</fieldset>
    
    
    </>
  )
}

export default RegisterUser