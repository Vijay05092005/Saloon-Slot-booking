function goToApp(contextPath) {
    window.location.href = (contextPath || "") + "/index.jsp";
}

/* Counter Animation */
const counters = document.querySelectorAll('.count');
counters.forEach(counter => {
    const update = () => {
        const target = +counter.dataset.target;
        const count = +counter.innerText;
        const inc = Math.ceil(target / 100);

        if (count < target) {
            counter.innerText = count + inc;
            setTimeout(update, 40);
        } else {
            counter.innerText = target;
        }
    };
    update();
});
