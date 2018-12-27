export default ({ app }, inject) => {
    app.router.beforeEach((to, from, next) => {
        if (to.path === '/' || !!app.router.app.$root.user) {
            next()
        } else {
            next('/')
        }
    })
}