import axios from "axios";
import { useEffect, useState } from "react";
import { useAudio } from "../ContextProvider/AudioContext";

const GetAllMusic = () => {
  const [song, setSong] = useState([]);
  const { playSong } = useAudio();

  useEffect(() => {
    axios
      .get("https://melodix-1.onrender.com/getallmusic")
      .then((res) => setSong(res.data.data))
      .catch((err) => console.log(err));
  }, []);

  return (
    <>
      
      <p
        className="
         lg:text-4xl text-4xl ml-4 lg:ml-8 mt-7 absolute
          sm:text-[clamp(1.3rem,4vw,1.6rem)]
           sm:mt-4 
        "
      >
        Songs
      </p>

      <div
        className="
          flex gap-4 mt-20
          sm:mt-14
          sm:px-4
          sm:overflow-x-auto
          sm:scrollbar-hide
        "
      >
        {song.map((item) => (
          <div
            key={item._id}
            className="
              bg-base-100 lg:w-48 flex-shrink-0 shadow-md mt-3 p-3 rounded-xl w-30 
              hover:bg-gray-600 transition group

              /* 📱 Mobile-only additions */
              sm:w-[clamp(9.5rem,42vw,11rem)]
            "
          >
           
            <div
              className="
                relative w-full lg:h-40 h-20   overflow-hidden rounded-xl
                sm:h-[clamp(7rem,32vw,8.5rem)]
              "
            >
              <img
                src={item.Image}
                className="lg:w-full lg:h-full w-25 h-25 object-cover rounded-xl"
              />

              <button
                onClick={() => playSong(item)}
                className="
                  absolute bottom-2 right-2 bg-green-600 text-white
                  w-10 h-10 rounded-full opacity-0 group-hover:opacity-100 transition

                  sm:w-9 sm:h-9 sm:text-sm 
                "
              >
                ▶
              </button>
            </div>

            
            <h2
              className="
                text-lg font-bold lg:mt-2
                sm:text-[clamp(0.9rem,4vw,1rem)]
              "
            >
              {item.Title}
            </h2>

            <h3
              className="
                text-gray-400 text-sm
                sm:text-[clamp(0.75rem,3.5vw,0.85rem)]
              "
            >
              {item.Singer}
            </h3>
          </div>
        ))}
      </div>
    </>
  );
};

export default GetAllMusic;
