import 'package:flutter/material.dart';

import 'package:movieapp/Home/Recommended/recomended_container.dart';

import 'package:movieapp/api/apimanager.dart';
import 'package:movieapp/fire_base/watch_list.dart';
import 'package:movieapp/model/SourceRecommended.dart';
import 'package:movieapp/theme.dart';

class Recommended_api extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SourceRecommended>(
      future: APIManager.getRecommended(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: MyTheme.orange,
          ));
        } else if (snapshot.hasError) {
          return Column(
            children: [
              Text('Something went wrong'),
              ElevatedButton(onPressed: () {}, child: Text('Try again'))
            ],
          );
        }
        if (snapshot.data?.page != 1) {
// server has code and message
          return Column(
            children: [
              Text(snapshot.data?.StatusMessage ?? ''),
              ElevatedButton(onPressed: () {}, child: Text('Try again'))
            ],
          );
        }
//data
        var resultList = snapshot.data?.results ?? [];
        return Container(
          margin: EdgeInsets.only(left: 15),
          padding: EdgeInsets.all(10),
          color: MyTheme.gray,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recomemded',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: 17),
              ),
              SizedBox(height: 4),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Recomended_Container(
                      results: resultList[index],
                      imagePath: resultList[index].posterPath ?? '',
                      favouriteMovie: onMovieFavourite(resultList[index]),
                    );
                  },
                  itemCount: resultList.length,
                ),
              )
            ],
          ),
        );
      },
    );
  }
  MovieData onMovieFavourite(Results addedMovie){
    Map<String, dynamic>  tmpmap ={
      "title" : addedMovie.title,
      "releaseDate": addedMovie.releaseDate,
      "posterPath": "${addedMovie.posterPath}",
    };
    MovieData movieData = MovieData.fromJson(tmpmap);
    return movieData;
  }
}
