import React, { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import RegisterUser from "../Components/RegisterUser";
import RegisterArtist from "../Components/RegisterArtist";

const RegisterPage = () => {
  const [activeTab, setActiveTab] = useState("user");

 
  const slideLeft = {
    initial: { x: "-100%", opacity: 0 },
    animate: { x: 0, opacity: 1 },
    exit: { x: "-100%", opacity: 0 },
  };

  const slideRight = {
    initial: { x: "100%", opacity: 0 },
    animate: { x: 0, opacity: 1 },
    exit: { x: "100%", opacity: 0 },
  };

  return (
    <div className="flex flex-col items-center w-full p-4">

      {/* ----- Tabs Buttons ----- */}
      <div className="flex gap-4 mb-6">
        <button
          className={`btn ${activeTab === "user" ? "btn-neutral" : "btn-outline"}`}
          onClick={() => setActiveTab("user")}
        >
          Register User
        </button>

        <button
          className={`btn ${activeTab === "artist" ? "btn-neutral" : "btn-outline"}`}
          onClick={() => setActiveTab("artist")}
        >
          Register Artist
        </button>
      </div>

      {/* ----- Animated Section ----- */}
      <div className="w-full max-w-xl">
        <AnimatePresence mode="wait">
          {activeTab === "user" && (
            <motion.div
              key="user"
              variants={slideLeft}
              initial="initial"
              animate="animate"
              exit="exit"
              transition={{ duration: 0.4 }}
            >
              <RegisterUser />
            </motion.div>
          )}

          {activeTab === "artist" && (
            <motion.div
              key="artist"
              variants={slideRight}
              initial="initial"
              animate="animate"
              exit="exit"
              transition={{ duration: 0.4 }}
            >
              <RegisterArtist />
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </div>
  );
};

export default RegisterPage;
