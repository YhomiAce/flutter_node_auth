const User = require("../models/user.model");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

exports.sigunp = async (req, res, next) => {
  try {
    console.log(req.body);
    const { email, name, password } = req.body;
    const user = await User.findOne({ email });
    if (user) {
      return res.status(400).send({
        message: "Email is already taken",
        success: false,
      });
    }
    const newUser = {
      email,
      name,
      password: bcrypt.hashSync(password, 10),
    };
    const createdUser = await User.create(newUser);
    return res.status(201).send({
      message: "User Registered successfully",
      success: true,
      data: {
        user: createdUser,
      },
    });
  } catch (error) {
    return res.status(500).send({
      message: "Server Error",
      success: false,
    });
  }
};

exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(401).send({
        message: "Invalid Email or Password",
        success: false,
      });
    }
    const isMatch = bcrypt.compareSync(password, user.password);
    if (!isMatch) {
      return res.status(401).send({
        message: "Invalid Email or Password",
        success: false,
      });
    }
    const payload = {
      user,
    };
    const token = jwt.sign(payload, process.env.JWT_TOKEN, {
      expiresIn: "1h",
    });
    return res.status(200).send({
      message: "User logged in successfully",
      success: true,
      data: {
        user,
        token,
      },
    });
  } catch (error) {
    return res.status(500).send({
      message: "Server Error",
      success: false,
    });
  }
};

exports.getUser = async (req, res, next) => {
  try {
    return res.status(200).send({
      success: true,
      data: {
        user: req.user,
        token: req.headers.authorization
      },
    });
  } catch (error) {
    return res.status(500).send({
      success: false,
      message: "Server Error",
    });
  }
};
// exports.getLoggedInUser = async (req, res) => {
//   try {
//     const user = JSON.parse(
//       JSON.stringify(await UserService.findUserById(req.user.id))
//     );
//     if (!user) {
//       return res.status(404).send({
//         success: false,
//         message: "No User Found",
//         user: null
//       });
//     }
//     let profile;
//     const data = {
//       ...user
//     };
//     const userId = user.id;
//     if (req.query.userType && req.query.userType !== "") {
//       const { userType } = req.query;
//       profile = await UserService.getUserTypeProfile(userType, userId);
//       if (profile) {
//         data.profile = profile;
//         data.userType = userType;
//       }
//     } else if (user.userType !== "admin") {
//       profile = await UserService.getUserTypeProfile(user.userType, userId);
//       if (profile) {
//         data.profile = profile;
//         data.userType = user.userType;
//       }
//     }

//     return res.status(200).send({
//       success: true,
//       user: data
//     });
//   } catch (error) {
//     return res.status(500).send({
//       success: false,
//       message: "Server Error"
//     });
//   }
// };
