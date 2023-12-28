describe("Send mail with PHP", () => {
  it("Should send an email with PHP", () => {
    let token = Cypress.env("MAILTRAP_TOKEN");
    let accountId = Cypress.env("MAILTRAP_ACCOUNTID");
    let inboxId = Cypress.env("MAILTRAP_INBOXID");

    expect(token).to.exist;
    expect(accountId).to.exist;
    expect(inboxId).to.exist;

    // Clean email inbox
    cy.request({
      method: "PATCH",
      url: `https://mailtrap.io/api/accounts/${accountId}/inboxes/${inboxId}/clean`,
      auth: {
        bearer: token,
      },
    });

    // Send email through PHP
    expect(Cypress.env("MAILTRAP_SUBJECT")).to.exist;
    cy.request({
      method: "GET",
      url: "localhost/mail-test.php",
      qs: {
        subject: Cypress.env("MAILTRAP_SUBJECT"),
      },
    });

    // Verify that the email arrived
    cy.request({
      method: "GET",
      url: `https://mailtrap.io/api/accounts/${accountId}/inboxes/${inboxId}/messages`,
      auth: {
        bearer: token,
      },
    }).should((response) => {
      expect(response.status).to.be.ok;
      expect(response.body).to.be.an("array");
      let actual = response.body.map((e) => ({
        subject: e.subject,
        from_email: e.from_email,
        to_email: e.to_email,
      }));
      expect(actual).to.deep.include.members([
        {
          subject: Cypress.env("MAILTRAP_SUBJECT"),
          from_email: "baikal@example.com",
          to_email: "to@example.com",
        },
      ]);
    });
  });
});
