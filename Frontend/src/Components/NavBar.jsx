import { useEffect, useState } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";
import default_profil from "../assets/profile_melodix.webp";

const NavBar = () => {
  const navigate = useNavigate();
  const token = localStorage.getItem("Token");

  const [search, setSearch] = useState("");
  const [result, setResult] = useState([]);
  const [loading, setLoading] = useState(false);

  const [profile, setProfile] = useState({
    Fullname: "",
    Email: "",
    Username: "",
    Image: "",
  });

  useEffect(() => {
    if (!token) return;

    axios
      .get("https://melodix-1.onrender.com/profile", {
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
      .post("https://melodix-1.onrender.com/searchmusic", { Title: search })
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
    navigate(token ? "/profile" : "/login");
  };

  const handlePlay = (song) => {
    navigate("/player", { state: { song, autoplay: true } });
  };

  const imgsrc = token && profile.Image ? profile.Image : default_profil;

  return (
    <nav
      className="
        fixed top-0 z-50
        w-[100vw]
        bg-base-100 shadow-md
        flex items-center justify-between
        px-[2vw]
        h-[clamp(3.5rem,4.5vw,5rem)]
      "
    >
      {/* Logo */}
      <div className="flex items-center">
        <span
          className="
            font-semibold
            text-[clamp(1rem,1.6vw,1.4rem)]
            cursor-pointer
          "
        >
          Melodix
        </span>
      </div>

      {/* Search */}
      <div className="relative flex-1 mx-[2vw] max-w-[50vw]">
        <input
          type="text"
          placeholder="What do you want to play?"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="
            w-full
            rounded-full
            input input-bordered
            px-[1.2vw]
            h-[clamp(2.3rem,3vw,3rem)]
            text-[clamp(0.85rem,1.1vw,1rem)]
          "
        />

        {search.trim() !== "" && (
          <div
            className="
              absolute top-[calc(100%+0.5vw)]
              w-full
              bg-gray-700 text-white
              rounded-xl shadow-lg
              max-h-[50vh]
              overflow-y-auto
              p-[1vw]
              flex flex-col gap-[0.8vw]
              z-50
            "
          >
            {loading && (
              <div className="text-center text-[clamp(0.8rem,1vw,0.95rem)]">
                Loading...
              </div>
            )}

            {!loading && result.length === 0 && (
              <div className="text-center text-[clamp(0.8rem,1vw,0.95rem)]">
                No result found
              </div>
            )}

            {!loading &&
              result.map((song, index) => (
                <div
                  key={index}
                  onClick={() => handlePlay(song)}
                  className="
                    flex items-center gap-[1vw]
                    p-[0.8vw]
                    rounded-lg
                    hover:bg-gray-600
                    cursor-pointer
                  "
                >
                  <img
                    src={song.Image || "https://via.placeholder.com/50"}
                    className="
                      w-[clamp(2.2rem,3vw,3rem)]
                      h-[clamp(2.2rem,3vw,3rem)]
                      rounded-lg
                      object-cover
                    "
                  />
                  <span
                    className="
                      truncate
                      text-[clamp(0.8rem,1vw,0.95rem)]
                    "
                  >
                    {song.Title}
                  </span>
                </div>
              ))}
          </div>
        )}
      </div>

      {/* Profile */}
      <div onClick={handleProfile} className="cursor-pointer">
        <div
          className="
            rounded-full overflow-hidden
            w-[clamp(2.2rem,3vw,2.8rem)]
            h-[clamp(2.2rem,3vw,2.8rem)]
          "
        >
          <img
            src={imgsrc}
            alt="Profile"
            className="w-full h-full object-cover"
          />
        </div>
      </div>
    </nav>
  );
};

export default NavBar;
