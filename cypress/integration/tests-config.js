describe('api-test', () => {
    it('GET', () => {
        cy.request('GET', 'https://snbeteyoeg.execute-api.us-east-1.amazonaws.com/').then((response) => {
            expect(response).to.have.property('status', 200)
            expect(response.body).to.not.be.null
            expect(response.body).to.be.a('string')
        })        
    })
})