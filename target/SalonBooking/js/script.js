let users = JSON.parse(localStorage.getItem("users")) || [];

// Toggle forms
function showRegister() {
    document.getElementById("loginForm").style.display = "none";
    document.getElementById("registerForm").style.display = "block";
    document.getElementById("loginTab").classList.remove("active-tab");
    document.getElementById("registerTab").classList.add("active-tab");
}

function showLogin() {
    document.getElementById("registerForm").style.display = "none";
    document.getElementById("loginForm").style.display = "block";
    document.getElementById("registerTab").classList.remove("active-tab");
    document.getElementById("loginTab").classList.add("active-tab");
}

// Register user
function registerUser() {
    let user = {
        name: regName.value,
        email: regEmail.value,
        password: regPassword.value,
        phone: regPhone.value,
        type: regType.value
    };

    let userExists = users.some(u => u.email === user.email);

    if (userExists) {
        alert("User already registered!");
    } else {
        users.push(user);
        localStorage.setItem("users", JSON.stringify(users));
        alert("Registration Successful!");
        showLogin();
    }
    return false;
}

// Login user
function loginUser() {
    let users = JSON.parse(localStorage.getItem("users")) || [];

    let email = loginEmail.value;
    let password = loginPassword.value;
    let type = loginType.value;

    let foundUser = users.find(
        u => u.email === email && u.type === type
    );

    if (!foundUser) {
        alert("User not found!");
        return false;
    }

    if (foundUser.password !== password) {
        alert("Invalid Password!");
        return false;
    }

    alert(type.toUpperCase() + " Login Successful");

    // ✅ TOMCAT-SAFE REDIRECT
    if (type === "customer") {
        window.location.href = "../user/products.jsp";
    } else {
        window.location.href = "adminDashboard.jsp"; // later servlet-based
    }

    return false;
}
