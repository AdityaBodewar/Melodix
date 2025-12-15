import React, { useEffect, useState } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom"; // Import useNavigate
import LoginPage from "../Pages/LoginPage";

const NavBar = () => {
  const [search, setSearch] = useState("");
  const [result, setResult] = useState([]);
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate(); // Initialize navigate

  useEffect(() => {
    if (search.trim() === "") {
      setResult([]);
      return;
    }

    setLoading(true);

    axios
      .post("http://localhost:5000/searchmusic", { Title: search })
      .then((res) => {
        setResult(res.data.data || []);
        setLoading(false);
      })
      .catch((err) => {
        console.log(err.response?.data?.message || "Error");
        setResult([]);
        setLoading(false);
      });
  }, [search]);

  const handlePlay = (song) => {
    
    navigate("/player", { state: { song, autoplay: true } });
  };

  const handleLogout=()=>{

    localStorage.removeItem('Token');
    localStorage.removeItem('Role');
    window.location.reload();


  }

   const token=localStorage.getItem('Token');

 

  if( !token)
  {
    return(
      <div className="navbar bg-base-100 shadow-sm flex justify-between h-20 relative">
      <div className="flex">
        <a className="btn btn-ghost text-xl">Melodix</a>
      </div>

      <div className="w-130 relative">
        <input
          type="text"
          placeholder="What do you want to play?"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="input input-bordered rounded-3xl md:w-full pl-4 h-13"
        />

        {search.trim() !== "" && (
          <div className="absolute left-0 top-14 w-full bg-gray-600 text-white shadow-lg rounded-xl max-h-80 overflow-y-auto z-50 p-2 flex flex-col gap-2">
            {loading && (
              <div className="p-2 bg-gray-600 text-white text-center">Loading...</div>
            )}

            {!loading && result.length === 0 && (
              <div className="p-2 bg-gray-600 text-white text-center">No result found</div>
            )}

            {!loading &&
              result.length > 0 &&
              result.map((song, index) => (
                <div
                  key={index}
                  className="flex items-center bg-gray-700 p-2 rounded-xl cursor-pointer hover:shadow-md transition gap-3"
                  onClick={() => handlePlay(song)} // Redirect to PlayerPage
                >
                  <img
                    src={song.Image || "https://via.placeholder.com/50"}
                    alt={song.Title}
                    className="w-12 h-12 rounded-lg object-cover"
                  />
                  <span className="text-sm text-white font-medium">{song.Title}</span>
                </div>
              ))}
          </div>
        )}
      </div>

      <div className="dropdown dropdown-end">
        <div
          tabIndex={0}
          role="button"
          className="btn btn-ghost btn-circle avatar"
        >
          
          <div className="w-10 rounded-full">
            <img src="https://img.daisyui.com/images/stock/photo-1534528741775-53994a69daeb.webp" />
          </div>
        </div>
        <ul
          tabIndex="-1"
          className="menu menu-sm dropdown-content bg-base-100 rounded-box z-1 mt-3 w-52 p-2 shadow"
        >
          <li><a href="/login">Login</a></li>
          
        </ul>
      </div>
    </div>

    )
  }

  return (
    <div className="navbar bg-base-100 shadow-sm flex justify-between h-20 relative">
      <div className="flex">
        <a className="btn btn-ghost text-xl">Melodix</a>
      </div>

      <div className="w-130 relative">
        <input
          type="text"
          placeholder="What do you want to play?"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="input input-bordered rounded-3xl md:w-full pl-4 h-13"
        />

        {search.trim() !== "" && (
          <div className="absolute left-0 top-14 w-full bg-gray-600 text-white shadow-lg rounded-xl max-h-80 overflow-y-auto z-50 p-2 flex flex-col gap-2">
            {loading && (
              <div className="p-2 bg-gray-600 text-white text-center">Loading...</div>
            )}

            {!loading && result.length === 0 && (
              <div className="p-2 bg-gray-600 text-white text-center">No result found</div>
            )}

            {!loading &&
              result.length > 0 &&
              result.map((song, index) => (
                <div
                  key={index}
                  className="flex items-center bg-gray-700 p-2 rounded-xl cursor-pointer hover:shadow-md transition gap-3"
                  onClick={() => handlePlay(song)} // Redirect to PlayerPage
                >
                  <img
                    src={song.Image || "https://via.placeholder.com/50"}
                    alt={song.Title}
                    className="w-12 h-12 rounded-lg object-cover"
                  />
                  <span className="text-sm text-white font-medium">{song.Title}</span>
                </div>
              ))}
          </div>
        )}
      </div>

      <div className="dropdown dropdown-end">
        <div
          tabIndex={0}
          role="button"
          className="btn btn-ghost btn-circle avatar"
        >
          
          <div className="w-10 rounded-full">
            <img src="https://img.daisyui.com/images/stock/photo-1534528741775-53994a69daeb.webp" />
          </div>
        </div>
        <ul
          tabIndex="-1"
          className="menu menu-sm dropdown-content bg-base-100 rounded-box z-1 mt-3 w-52 p-2 shadow"
        >
          <li><a href="/profile">Profile</a></li>
          <li><a>Settings</a></li>
          <li><a onClick={handleLogout}>Logout</a></li>
        </ul>
      </div>
    </div>
  );
};

export default NavBar;
