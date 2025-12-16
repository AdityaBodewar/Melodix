import { useEffect, useState } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom"; 
import default_profil from "../assets/profile_melodix.webp";

const NavBar = () => {
  const navigate = useNavigate();

  const token = localStorage.getItem("Token"); // ✅ move up

  const [search, setSearch] = useState("");
  const [result, setResult] = useState([]);
  const [loading, setLoading] = useState(false);

  const [profile, setProfile] = useState({
    Fullname: "",
    Email: "",
    Username: "",
    Image: "",
  });

  // ✅ Fetch profile ONLY if token exists
  useEffect(() => {
    if (!token) return;

    axios
      .get("http://localhost:5000/profile", {
        headers: { Authorization: `Bearer ${token}` },
      })
      .then((res) => setProfile(res.data))
      .catch((err) => console.log(err));
  }, [token]);

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
      .catch(() => {
        setResult([]);
        setLoading(false);
      });
  }, [search]);

  const handleProfile = () => {
    if (token) navigate("/profile");
    else navigate("/login");
  };

  const handlePlay = (song) => {
    navigate("/player", { state: { song, autoplay: true } });
  };

  // ✅ Correct image logic
  let imgsrc = default_profil;
  if (token && profile.Image) {
    imgsrc = profile.Image;
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
            {loading && <div className="text-center">Loading...</div>}
            {!loading && result.length === 0 && <div className="text-center">No result found</div>}

            {!loading &&
              result.map((song, index) => (
                <div
                  key={index}
                  className="flex items-center bg-gray-700 p-2 rounded-xl cursor-pointer gap-3"
                  onClick={() => handlePlay(song)}
                >
                  <img
                    src={song.Image || "https://via.placeholder.com/50"}
                    className="w-12 h-12 rounded-lg"
                  />
                  <span>{song.Title}</span>
                </div>
              ))}
          </div>
        )}
      </div>

     
      <div className="dropdown dropdown-end"  onClick={handleProfile}>
        <div
          tabIndex={0}
          role="button"
          className="btn btn-ghost btn-circle avatar"
         
        >
          <div className="w-10 rounded-full">
            <img src={imgsrc} alt="Profile" />
          </div>
        </div>
      </div>
    </div>
  );
};

export default NavBar;
