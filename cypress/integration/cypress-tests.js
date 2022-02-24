describe('response status is 200', () => {
    it('GET', () => {
        cy.request('GET', 'https://snbeteyoeg.execute-api.us-east-1.amazonaws.com/')
        .then((res) => {expect(res).to.have.property('status', 200)
        })        
    })
})

describe('response body is not null', () => {
    it('GET', () => {
        cy.request('GET', 'https://snbeteyoeg.execute-api.us-east-1.amazonaws.com/')
        .then((res) => {expect(res.body).to.not.be.null
        })        
    })
})

// describe('response body count element is positive number', () => {
//     it('GET', () => {
//         cy.request('GET', 'https://snbeteyoeg.execute-api.us-east-1.amazonaws.com/').then((res) => {
//             expect(res.body.count).to.be.greaterThan(0)
//         })        
//     })
// })