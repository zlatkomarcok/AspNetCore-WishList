FROM microsoft/dotnet:2.0-sdk AS build-env
WORKDIR /app

# copy csproj and restore as distinct layers
COPY ./WishList/*.csproj ./
RUN dotnet restore

# copy everything else and build
COPY ./WishList/. ./
RUN dotnet publish -c Release -o out /p:PublishWithAspNetCoreTargetManifest="false"

# build runtime image
FROM microsoft/dotnet:2.0-runtime
WORKDIR /app
COPY --from=build-env /app/out .
# not valid for Heroku
# ENTRYPOINT ["dotnet", "WishList.dll"]
# this is working
CMD ASPNETCORE_URLS="http://*:$PORT" dotnet WishList.dll
