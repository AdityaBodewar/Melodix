import axios from 'axios';
import React, { useState } from 'react'
import { useNavigate } from 'react-router-dom';

const Login = () => {


    const [user,setUser]=useState({"Email":"","Password":""});
    const navigate=useNavigate();

   const  handleChange=(e)=>{

    setUser({...user,[e.target.name]:e.target.value});

   } 
   const handleSubmit=()=>{

    axios.post("https://melodix-1.onrender.com/login",user)
    .then(res=>{alert(res.data.message);
       const token=res.data.Token;
       const role=res.data.Role;
        localStorage.setItem('Token',token);
        localStorage.setItem('Role',role);
        navigate('/');
    })
   .catch(error => {
  alert(error.response?.data?.error || "Login failed");
});

   }
  return (
    <>


    <fieldset className="fieldset bg-base-200 border-base-300 rounded-box w-xs border p-4 lg:ml-[650px] ml-10 mt-[150px]">
  <legend className="fieldset-legend">Login</legend>

  <label className="label">Email</label>
  <input type="email" className="input" placeholder="Email" name='Email' value={user.Email} onChange={handleChange} />

  <label className="label">Password</label>
  <input type="password" className="input" placeholder="Password" name='Password' value={user.Password} onChange={handleChange} />

  <button className="btn btn-neutral mt-4"  onClick={handleSubmit}>Login</button>

 <p className='text-[15px] p-5 '>dont have an account ? <a className='text-blue-600 ' href="/register">Sign up </a></p>
</fieldset>
    
    </>
  )
}

export default Login