import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

const GetAllArtist = () => {
  const [artists, setArtists] = useState([]);
  const navigate = useNavigate();

  useEffect(() => {
    fetch("http://localhost:5000/getallartist")
      .then((res) => res.json())
      .then((data) => {
    
        const artistsData = data.artist.map((a) => ({
          ...a, 
         
          _id: a._id?.$oid || a._id?.toString() || String(a._id),
        }));
        setArtists(artistsData);
      })
      .catch((err) => console.error("Error fetching artists:", err));
  }, []);

  const handleArtist = (item) => {
    
    navigate("/aboutartist", { state: item });
  };

  return (
    <>
    <p className="text-4xl ml-8 mt-7 absolute">Artist</p>
    <div className="flex gap-4 mt-20">
    
      {artists.length > 0 ? (
        artists.map((item) => (
          <div
            key={item._id}
            onClick={() => handleArtist(item)}
            className="bg-base-100 w-48 flex-shrink-0 shadow-md mt-3 p-3 rounded-xl hover:bg-gray-600 transition group"
          >
            <div className="relative w-full h-40 overflow-hidden rounded-xl">
              <img
                src={item.Image || "https://via.placeholder.com/150"}
                alt={item.Fullname}
                className="w-full h-full object-cover rounded-xl"
              />
            </div>

            <h2 className="text-lg font-bold mt-2">{item.Fullname}</h2>
            <h3 className="text-gray-400 text-sm">{item.Type}</h3>
          </div>
        ))
      ) : (
        <p>No artists found.</p>
      )}
    </div>
    </>
  );
};

export default GetAllArtist;