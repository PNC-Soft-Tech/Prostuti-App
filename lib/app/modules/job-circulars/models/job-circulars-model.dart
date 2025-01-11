class JobCircular {
  final String id;
  final String title;
  final String experience;
  final String educationalQualification;
  final String address;
  final String image;
  final String company;
  final JobCategory jobCategory;
  final DateTime deadline;
  final String link;

  JobCircular({
    required this.id,
    required this.title,
    required this.experience,
    required this.educationalQualification,
    required this.address,
    required this.image,
    required this.company,
    required this.jobCategory,
    required this.deadline,
    required this.link,
  });

  factory JobCircular.fromJson(Map<String, dynamic> json) {
    return JobCircular(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      experience: json['experience'] ?? '',
      educationalQualification: json['educationalQualification'] ?? '',
      address: json['address'] ?? '',
      image: json['image'] ?? '',
      company: json['company'] ?? '',
      jobCategory: JobCategory.fromJson(json['jobCategory']),
      deadline: DateTime.parse(json['deadline']),
      link: json['link'] ?? '',
    );
  }
}

class JobCategory {
  final String id;
  final String name;
  final String slug;

  JobCategory({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory JobCategory.fromJson(Map<String, dynamic> json) {
    return JobCategory(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}
