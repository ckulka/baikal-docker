describe("Send mail with PHP", () => {
  it(
    "Should send an email with PHP",
    {
      // Retry to address flakiness of sending and receiving emails
      retries: {
        runMode: 3,
        openMode: 3,
      },
    },
    () => {
      let token = Cypress.env("MAILTRAP_TOKEN");
      let accountId = Cypress.env("MAILTRAP_ACCOUNTID");
      let inboxId = Cypress.env("MAILTRAP_INBOXID");

      expect(token, "No mailtrap API token MAILTRAP_TOKEN").to.exist;
      expect(accountId, "No mailtrap account id MAILTRAP_ACCOUNTID").to.exist;
      expect(inboxId, "No mailtrap inbox id MAILTRAP_INBOXID").to.exist;

      // Send email through PHP
      let subject = `Cypress ${crypto.randomUUID()}`;
      cy.request({
        method: "GET",
        url: "localhost/mail-test.php",
        qs: {
          subject: subject,
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
        expect(response.body).to.be.an("array");
        let actual = response.body.map((e) => ({
          subject: e.subject,
          from_email: e.from_email,
          to_email: e.to_email,
        }));
        expect(actual).to.deep.include.members([
          {
            subject: subject,
            from_email: "baikal@example.com",
            to_email: "to@example.com",
          },
        ]);
      });
    },
  );
});
