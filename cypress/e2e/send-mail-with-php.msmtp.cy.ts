describe("Send mail with PHP", () => {
  it("Should send an email with PHP", () => {
    // Send email through PHP (response of mail-test.php is the email subject)
    cy.request("localhost/mail-test.php").then((response) => {
      // Verify that the email arrived
      cy.request({
        url: "localhost:8080/mail",
        qs: {
          subject: response.body,
        },
      }).should((response) => {
        expect(response.body.totalRecords).to.eql(1);
        const mail = response.body.mailItems[0];
        expect(mail.fromAddress).to.eql("baikal@example.com");
        expect(mail.toAddresses).to.eql(["to@example.com"]);
        expect(mail.body).to.match(/Email sent with PHP mail\(\)\r?\n/);
      });
    });
  });
});
