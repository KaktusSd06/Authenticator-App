import '../../models/service.dart';

//FIXME я б винесла це в presentation, бо data шар не повинен нічого знати про твою реалізацію на ui. А ти тут вказуєш, що ти зображення береш з асетів.
final Map<String, List<Service>> serviceCategories = {
  "General": [
    Service(name: "Banking and finance", iconPath: "assets/icons/banking.svg"),
    Service(name: "Website", iconPath: "assets/icons/website.svg"),
    Service(name: "Mail", iconPath: "assets/icons/mail.svg"),
    Service(name: "Social", iconPath: "assets/icons/social.svg"),
  ],
  "Services": [
    Service(name: "Google", iconPath: "assets/icons/google.svg"),
    Service(name: "Instagram", iconPath: "assets/icons/instagram.svg"),
    Service(name: "Facebook", iconPath: "assets/icons/facebook.svg"),
    Service(name: "LinkedIn", iconPath: "assets/icons/linkedin.svg"),
    Service(name: "Microsoft", iconPath: "assets/icons/microsoft.svg"),
    Service(name: "Discord", iconPath: "assets/icons/discord.svg"),
    Service(name: "Netflix", iconPath: "assets/icons/netflix.svg"),
  ],
};
