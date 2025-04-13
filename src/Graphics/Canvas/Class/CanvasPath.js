export function closePath_(ctx) {
    ctx.closePath();
}

export function moveTo_(ctx, p) {
    ctx.moveTo(p.x, p.y);
}

export function lineTo_(ctx, p) {
    ctx.lineTo(p.x, p.y);
}

export function quadraticCurveTo_(ctx, c, p) {
    ctx.quadraticCurveTo(c.x, c.y, p.x, p.y);
}

export function bezierCurveTo_(ctx, c1, c2, p) {
    ctx.bezierCurveTo(c1.x, c1.y, c2.x, c2.y, p.x, p.y);
}

export function arcTo_(ctx, c1, c2, r) {
    ctx.arcTo(c1.x, c1.y, c2.x, c2.y, r);
}

export function rect_(ctx, r) {
    ctx.rect(r.x, r.y, r.w, r.h);
}

export function roundRect_(ctx, rc, rds) {
    ctx.roundRect(rc.x, rc.y, rc.w, rc.h, rds);
}

export function arc_(ctx, p, r, as, ccw) {
    ctx.arc(p.x, p.y, r, as.start, as.end, ccw);
}

export function ellipse_(ctx, p, r, rot, as, ccw) {
    ctx.ellipse(p.x,
                p.y,
                r.semiMajor,
                r.semiMinor,
                rot,
                as.start,
                as.end,
                ccw);
}
