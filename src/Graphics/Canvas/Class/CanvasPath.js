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
    cts.roundRect(rc.x, rc.y, rc.w, rc.h, rds);
}

export function arc_(ctx, p, ) {

}

export function ellipse_() {

}
