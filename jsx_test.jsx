import React from "react";
import Card from "./card";

export default class CardList extends React.Component {
  constructor(props) {
    super(props);
  }

  render () {
    var card_list = this.props.deck_list.map(function(card) {
      return (
        <Card key={card.id} card={card} />
      );
    });

    return (
      <div className="card-list">
        <h3>{this.props.name}</h3>
        {card_list}
      </div>
    );
  }
}
