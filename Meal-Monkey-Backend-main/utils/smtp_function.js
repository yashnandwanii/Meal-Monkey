import nodemailer from 'nodemailer';

const sendEmail = async (userEmail, message) => {

    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth:{
            user: process.env.EMAIL_USER,
            pass: process.env.EMAIL_PASSWORD
        }
    });

    const mailOptions = {
        from: process.env.EMAIL_USER,
        to: userEmail,
        subject: "Meal Monkey's Verification code",
        html: `<h1> Meal Monkey's Verification Code</h1>
        <p>Dear User,</p>
        <p>Thank you for registering with Meal Monkey. Please use the following verification code to complete your registration:</p>
        <h2 style="color: #4CAF50;">${message}</h2>
        <p>If you did not request this code, please ignore this email.</p>
        <p>Best regards,</p>
        <p>Meal Monkey Team</p>`
    };  

    try {
        await transporter.sendMail(mailOptions);
        console.log('Email sent successfully');
    } catch (error) {
        console.error('Error sending email:', error);
        throw new Error('Failed to send email');
    }
}

export default sendEmail;