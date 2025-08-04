function generateOTP(length = 6) {
   
    const otp = Math.floor(100000 + Math.random() * 900000);
    return otp.toString().substring(0, length);
}

export default generateOTP;