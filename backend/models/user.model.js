const mongoose = require('mongoose');

const Schema = mongoose.Schema;

const userSchema = new Schema({
    email: String,
    name: String,
    password: String,
});

module.exports = User = mongoose.model('User', userSchema);