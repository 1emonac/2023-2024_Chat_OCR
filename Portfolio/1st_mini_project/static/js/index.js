
console.log('index.html');
gsap.registerPlugin(Physics2DPlugin);

document.querySelectorAll('div').forEach(div => {

    const bounding = div.getBoundingClientRect()

    div.addEventListener('mousemove', e => {

        let dy = (e.clientY - bounding.top - bounding.height / 2) / -1
        let dx = (e.clientX - bounding.left - bounding.width / 2)  / 10

        dy = dy > 10 ? 10 : (dy < -10 ? -10 : dy);
        dx = dx > 4 ? 4 : (dx < -4 ? -4 : dx);

        div.style.setProperty('--rx', dy);
        div.style.setProperty('--ry', dx);

    });

    div.addEventListener('mouseleave', e => {

        div.style.setProperty('--rx', 0)
        div.style.setProperty('--ry', 0)

    });

    div.addEventListener('click', e => {
        div.classList.add('success');
        gsap.to(div, {
            '--icon-x': -3,
            '--icon-y': 3,
            '--z-before': 0,
            duration: .2,
            onComplete() {
                particles(div.querySelector('.emitter'), 100, -4, 6, -80, -50);
                gsap.to(div, {
                    '--icon-x': 0,
                    '--icon-y': 0,
                    '--z-before': -6,
                    duration: 1,
                    ease: 'elastic.out(1, .5)',
                    onComplete() {
                        div.classList.remove('success');
                    }
                });
            }
        });
    });

});

function particles(parent, quantity, x, y, minAngle, maxAngle) {
    let colors = [
        '#FFFF04',
        '#EA4C89',
        '#892AB8',
        '#4AF2FD',
    ];
    for(let i = quantity - 1; i >= 0; i--) {
        let angle = gsap.utils.random(minAngle, maxAngle),
            velocity = gsap.utils.random(70, 140),
            dot = document.createElement('div');
        dot.style.setProperty('--b', colors[Math.floor(gsap.utils.random(0, 4))]);
        parent.appendChild(dot);
        gsap.set(dot, {
            opacity: 0,
            x: x,
            y: y,
            scale: gsap.utils.random(.4, .7)
        });
        gsap.timeline({
            onComplete() {
                dot.remove();
            }
        }).to(dot, {
            duration: .05,
            opacity: 1
        }, 0).to(dot, {
            duration: 1.8,
            rotationX: `-=${gsap.utils.random(720, 1440)}`,
            rotationZ: `+=${gsap.utils.random(720, 1440)}`,
            physics2D: {
                angle: angle,
                velocity: velocity,
                gravity: 120
            }
        }, 0).to(dot, {
            duration: 1,
            opacity: 0
        }, .8);
    }
}
         