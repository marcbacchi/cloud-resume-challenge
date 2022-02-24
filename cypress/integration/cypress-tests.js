describe('api-test', () => {
    it('GET', () => {
        cy.request('GET', 'https://snbeteyoeg.execute-api.us-east-1.amazonaws.com/').then((res) => {
            expect(res).to.have.property('status', 200)
            expect(res.body).to.not.be.null
            expect(res.body).to.be.greaterThan(0)
        })        
    })
})