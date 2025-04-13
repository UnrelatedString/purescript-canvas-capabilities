export function beginPath_(ctx) {
    ctx.beginPath();
}

export function fill_(path, ctx, style) {
    ctx.fill(...path, style);
}

export function stroke_(path, ctx) {
    ctx.stroke(...path);
}

export function clip_(path, ctx, style) {
    ctx.clip(...path, style);
}

export function isPointInPath_(path, ctx, p, style) {
    return ctx.isPointInPath(...path, p.x, p.y, style);
}

export function isPointInStroke_(path, ctx, p) {
    return ctx.isPointInStroke(...path, p.x, p.y);
}
