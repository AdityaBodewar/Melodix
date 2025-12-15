import React, { useEffect, useState } from "react";
import axios from "axios";

const Profile = () => {
  const [isEditing, setIsEditing] = useState(false);
  const [profile, setProfile] = useState({
    Fullname: "",
    Email: "",
    Username: "",
    Image: "", // base64 or URL
  });

  const [imageFile, setImageFile] = useState(null); // actual file for upload
  const token = localStorage.getItem("Token");

  // 🔹 GET PROFILE
  useEffect(() => {
    axios
      .get("http://localhost:5000/profile", {
        headers: { Authorization: `Bearer ${token}` },
      })
      .then((res) => setProfile(res.data))
      .catch((err) => console.log(err));
  }, []);

  // 🔹 INPUT CHANGE
  const handleChange = (e) => {
    const { name, value } = e.target;
    setProfile((prev) => ({ ...prev, [name]: value }));
  };

  // 🔹 IMAGE → PREVIEW & STORE FILE
  const handlePhotoChange = (e) => {
    const file = e.target.files[0];
    if (!file) return;

    setImageFile(file); // store file for sending
    const reader = new FileReader();
    reader.onloadend = () => {
      setProfile((prev) => ({ ...prev, Image: reader.result })); // preview
    };
    reader.readAsDataURL(file);
  };

  // 🔹 UPDATE PROFILE
  const saveProfile = async () => {
    try {
      const formData = new FormData();
      formData.append("Fullname", profile.Fullname);
      formData.append("Email", profile.Email);
      formData.append("Username", profile.Username);
      if (imageFile) {
        formData.append("Image", imageFile); // send file if selected
      }

      await axios.put("http://localhost:5000/profile", formData, {
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "multipart/form-data",
        },
      });

      setIsEditing(false);
      setImageFile(null); // reset file input
      alert("Profile updated successfully!");
    } catch (err) {
      console.error(err);
      alert("Error updating profile");
    }
  };

  return (
    <div style={styles.container}>
      <div style={styles.card}>
        {/* Profile Photo */}
        <div style={styles.photoSection}>
          <div style={styles.photoBox}>
            {profile.Image ? (
              <img src={profile.Image} alt="Profile" style={styles.photo} />
            ) : (
              <span style={styles.photoText}>Profile Photo</span>
            )}
          </div>
          {isEditing && (
            <input type="file" accept="image/*" onChange={handlePhotoChange} />
          )}
        </div>

        {/* Full Name */}
        <div style={styles.field}>
          <label>Full Name</label>
          {isEditing ? (
            <input name="Fullname" value={profile.Fullname} onChange={handleChange} />
          ) : (
            <p>{profile.Fullname}</p>
          )}
        </div>

        {/* Email */}
        <div style={styles.field}>
          <label>Email</label>
          {isEditing ? (
            <input name="Email" value={profile.Email} onChange={handleChange} />
          ) : (
            <p>{profile.Email}</p>
          )}
        </div>

        {/* Username */}
        <div style={styles.field}>
          <label>Username</label>
          {isEditing ? (
            <input name="Username" value={profile.Username} onChange={handleChange} />
          ) : (
            <p>{profile.Username}</p>
          )}
        </div>

        <button
          style={styles.button}
          onClick={isEditing ? saveProfile : () => setIsEditing(true)}
        >
          {isEditing ? "Save Profile" : "Edit Profile"}
        </button>
      </div>
    </div>
  );
};

const styles = {
  container: { minHeight: "100vh", display: "flex", justifyContent: "center", alignItems: "center" },
  card: { width: "320px", padding: "20px", border: "1px solid #ccc", borderRadius: "10px" },
  photoSection: { textAlign: "center", marginBottom: "15px" },
  photoBox: { width: "120px", height: "120px", borderRadius: "50%", border: "1px solid #aaa", margin: "0 auto 10px", overflow: "hidden" },
  photo: { width: "100%", height: "100%", objectFit: "cover" },
  photoText: { fontSize: "12px" },
  field: { marginBottom: "12px" },
  button: { width: "100%", padding: "8px", cursor: "pointer" },
};

export default Profile;
