# Winery Presentation

## Group Introduction

Probably just one slide, noting that we are Gold Team, and the team members.

## Case Study

Bacchus Winery is a small business run by Stan and Davis Bacchus. They employ roughly 25 people, and face a number of challenges which require data collection and analysis.

---

**Challenges and Questions**

- How many hours did employees work each quarter?
- Are suppliers delivering on time?
- Which distributors carry which wines?
- Are some wines underperforming?

## ERD

We chose this design based on the needs expressed in the case study

*(The finalized ERD)*
*We will probably split the ERD onto 3 slides for clarity*

## Reports

### Quarterly Hours by Employee

This report shows a summary of hours worked per employee. It covers a whole year divided in quarters. This allows the managers to have an accurate representation of total hours each employee worked during the last four quarters. 


![image](https://hackmd.io/_uploads/B1_75HofZg.png)




### Monthly Delivery Timeliness by Vendor

This report is an overview of the supply orders this month. It highlights which suppliers are delivering on time, which are delivering late, and how late they are on average. With this, the winery will be able to tell at a glance if there are large gaps between expected delivery and actual delivery.

![image](https://hackmd.io/_uploads/ryCZ6BsGbx.png)


### Underperforming Wines


This report lists any wines that fall below a predetermined sales volume, so that the winery can discover if any wines are not selling as expected. This "acceptable sales volume" is adjustable, and can grow as the company expands.


![image](https://hackmd.io/_uploads/Hy3j3Hofbx.png)




## Assumptions, Uncertainties

### Timekeeping Assumptions
- The winery does not need a computer system to track employee departments, wages, etc. - only hours worked.
- There is no need to track hours very closely; only the total worktime each day is needed.

### Wine Assumptions
- The wines and distributors list could grow quite large, so we rejected some more compact report formats
- Wine sales can be tracked using one uniform unit of sale (such as bottles) across the entire catalogue.

### Shipping and Supply Assumptions
- Each ingredient has only one preferred supplier
- A shipment to or from the winery is small enough that
  - it can all be shipped at once
  - on the same carrier
  - and needs only one tracking number.

### Stockkeeping Assumptions
- We do not need to keep track of supply or product locations
- Suppies come in some trackable unit, and each item of supply is indistinguishable from another item.
- Stock does not spoil, and it's not necessary to track freshness.

## Conclusion
The newly implemented database provides Bacchus Winery with a centralized and reliable way to track suppliers, wine sales, distribution, and employee hours. It enables Stan and Davis to generate accurate reports showing supplier delivery performance, monthly sales trends by wine and distributor, and employee hours worked over the last four quarters.

By replacing manual tracking with relational data, the winery can now produce a clear yearly snapshot of the business, make informed decisions, and improve efficiency. This system also creates a strong foundation for future growth. 
