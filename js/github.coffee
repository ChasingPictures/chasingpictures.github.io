---
---
# Calculates the maximum of an array, applying the key function to every element
maxBy = (array, key) ->
    if (not key?)
        return Math.max(null, array)
    else
        return array.reduce((last, current) ->
            if (not last? || key(current) > key(last))
                return current
            else
                return last
        , null)

Array::maxBy = maxBy

# Retrieves the latest of the given releases
# somehow, calling the prototype function does not work...
latest = (releases) -> maxBy releases, (rel) -> Date.parse rel.publishedAt

# Filters a release so only the assets of type '.apk' remain
androidApps = (release) ->
    release.assets = release.assets.filter (asset, index, array) ->
        asset.contentType == "application/vnd.android.package-archive"
    return release

# Calculates the size of the given asset in megabytes
size = (asset) ->
    Math.round(100 * asset.size / Math.pow(1024, 2)) / 100

# Inserts a download link to the latest release
insertLatestDownloadLink = (releases, title, container, filter = (x) -> x) ->
    release = latest releases
    app = filter(release).assets[0]
    sizeMB = size app
    version = release.tagName

    a = document.createElement('a');
    a.href = app.browserDownload.url;
    a.innerHTML = 'Download ' + title + ' (' + version + ') (' + sizeMB + ' MB)';
    container.appendChild a

# Insert a download link to the latest Android app
# into the containter with the given id
downloadLink = (containerId) ->
    octo = new Octokat()
    repo = octo.repos('{{ site.github_username }}', '{{ site.github.main_repo }}')
    repo.releases.fetch().then (releases) ->
        insertLatestDownloadLink(releases, 'Chasing Pictures', document.getElementById containerId, androidApps)

# Export function
window.downloadLink = downloadLink
