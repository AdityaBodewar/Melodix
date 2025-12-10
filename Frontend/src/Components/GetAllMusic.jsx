import axios from "axios";
import { useEffect, useState } from "react";
import Player from "./Player";
import { useNavigate } from "react-router-dom"; 

const GetAllMusic = () => {
  const [song, setSong] = useState([]);
  const navigate=useNavigate();

  useEffect(() => {
    axios
      .get("http://localhost:5000/getallmusic")
      .then((res) => setSong(res.data.data))
      .catch((err) => console.log(err));
  }, []);

const handlePlayClick = (song) => {
    // Navigate to PlayerPage and pass song via state
    navigate("/player", { state: { song, autoplay: true } });
  };

  return (
    <div className="flex gap-4">
      {song.map((item) => (
        <div
          key={item._id}
          className="bg-base-100 w-48 flex-shrink-0 shadow-md mt-3 p-3 rounded-xl hover:bg-gray-600 transition group"
        >
          <div className="relative w-full h-40 overflow-hidden rounded-xl">
            <img
              src={item.Image}
              className="w-full h-full object-cover rounded-xl"
            />

            <button
              onClick={() => handlePlayClick(item)}
              className="absolute bottom-2 right-2 bg-green-600 text-white w-10 h-10 rounded-full opacity-0 group-hover:opacity-100 transition"
            >
              ▶
            </button>
          </div>

          <h2 className="text-lg font-bold mt-2">{item.Title}</h2>
          <h3 className="text-gray-400 text-sm">{item.Singer}</h3>

          
        </div>
      ))}
    </div>
  );
};

export default GetAllMusic;
