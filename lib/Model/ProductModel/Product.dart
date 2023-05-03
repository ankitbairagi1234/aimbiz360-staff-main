import 'package:eshopmultivendor/Helper/String.dart';
import 'Attribute.dart';
import 'FilterModel.dart';
import 'Variants.dart';

class Product {
  String? id,
      name,
      desc,
      image,
      catName,
      type,
      rating,
      noOfRating,
      attrIds,
      tax,
      categoryId,
      shortDescription,
      stock;
  List<String>? otherImage;
  List<Product_Varient>? prVarientList;
  List<Attribute>? attributeList;
  List<String>? selectedId = [];
  List<String>? tagList = [];
  String? isFav,
      isReturnable,
      isCancelable,
      isPurchased,
      availability,
      madein,
      indicator,
      stockType,
      cancleTill,
      total,
      banner,
      totalAllow,
      video,
      videType,
      warranty,
      gurantee;

  bool? isFavLoading = false, isFromProd = false;
  int? offset, totalItem, selVarient;

  List<Product>? subList;
  List<Filter>? filterList;

  Product(
      {this.id,
      this.name,
      this.desc,
      this.image,
      this.catName,
      this.type,
      this.otherImage,
      this.prVarientList,
      this.attributeList,
      this.isFav,
      this.isCancelable,
      this.isReturnable,
      this.isPurchased,
      this.availability,
      this.noOfRating,
      this.attrIds,
      this.selectedId,
      this.rating,
      this.isFavLoading,
      this.indicator,
      this.madein,
      this.tax,
      this.shortDescription,
      this.total,
      this.categoryId,
      this.subList,
      this.filterList,
      this.stockType,
      this.isFromProd,
      this.cancleTill,
      this.totalItem,
      this.offset,
      this.totalAllow,
      this.banner,
      this.selVarient,
      this.video,
      this.videType,
      this.tagList,
      this.warranty,
      this.stock,
      this.gurantee});

  factory Product.fromJson(Map<String, dynamic> json) {
    List<Product_Varient> varientList = (json[Variants] as List)
        .map((data) => new Product_Varient.fromJson(data))
        .toList();

    List<Attribute> attList = (json[Attributes] as List)
        .map((data) => new Attribute.fromJson(data))
        .toList();

    var flist = (json[FILTERS] as List?);
    List<Filter> filterList = [];
    if (flist == null || flist.isEmpty)
      filterList = [];
    else
      filterList = flist.map((data) => new Filter.fromJson(data)).toList();

    List<String> other_image = List<String>.from(json[OtherImagesMd]);
    List<String> selected = [];

    return new Product(
      id: json[Id],
      name: json[Name],
      desc: json[Description],
      image: json[IMage],
      catName: json[CategoryName],
      rating: json[Rating],
      noOfRating: json[NoOfRatings],
      stock: json[Stock],
      type: json[Type],
      isFav: json[IsFavorite].toString(),
      isCancelable: json[IsCancelable],
      availability: json[Availability].toString(),
      isPurchased: json[IsPurchased].toString(),
      isReturnable: json[IsReturnable],
      otherImage: other_image,
      prVarientList: varientList,
      attributeList: attList,
      filterList: filterList,
      isFavLoading: false,
      selVarient: 0,
      attrIds: json[AttrValueIds],
      madein: json[MadeIn],
      indicator: json[Indicator].toString(),
      stockType: json[StockType].toString(),
      tax: json[TaxPercentage],
      total: json[Total],
      categoryId: json[CategoryId],
      selectedId: selected,
      totalAllow: json[TotalAllowedQuantity],
      cancleTill: json[CancelableTill],
    );
  }

  factory Product.fromCat(Map<String, dynamic> parsedJson) {
    return new Product(
      id: parsedJson[Id],
      name: parsedJson[Name],
      image: parsedJson[Images],
      banner: parsedJson[BANNER],
      isFromProd: false,
      offset: 0,
      totalItem: 0,
      tax: parsedJson[TAX],
      subList: createSubList(parsedJson["children"]),
    );
  }

  static List<Product>? createSubList(List? parsedJson) {
    if (parsedJson == null || parsedJson.isEmpty) return null;

    return parsedJson.map((data) => new Product.fromCat(data)).toList();
  }
}
