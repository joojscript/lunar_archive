export default `

.container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100vh;
  width: 100vw;
}

.container > * {
  margin: 0.5rem;
}

.container > *:first-child {
  margin-top: 0;
}


`;
