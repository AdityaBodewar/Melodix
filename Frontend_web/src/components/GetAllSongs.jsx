import axios from 'axios';
import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';

const GetAllSongs = () => {

  const [Songs, setSongs] = useState([]);

  useEffect(() => {
    axios.get("http://localhost:5000/getallmusic")
      .then(res => {
        console.log("Backend Response:", res.data);
        setSongs(res.data.data);  // <-- use "data"
      })
      .catch(err => {
        console.log(err);
      });
  }, []);

  return (
    <>
      <div className='flex flex-wrap justify-around w-full mt-10'>
        {Songs.map((item) => (
          <div
            className="card bg-base-100 w-50 h-fit pt-2 pb-1 shadow-sm border-1 mb-5"
            key={item._id}
          >
            <Link to={"/video-player"} state={{ videourl: item.Song }}>
              <figure>
                <img
                  className='w-45 h-65'
                  src={item.Image}
                  alt="song"
                />
              </figure>

              <h2 className="card-title">{item.Title}</h2>
              <h2 className="card-title">{item.Singer}</h2>
              <h2 className="card-title">{item.Type}</h2>
            </Link>
          </div>
        ))}
      </div>
    </>
  );
};

export default GetAllSongs;
